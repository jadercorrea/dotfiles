import Foundation
import Security

let service = "dev.jadercorrea.agent-secrets.v2"

func usage() -> Never {
    fputs("Usage: agent-keychain get|has|set NAME\n", stderr)
    exit(2)
}

guard CommandLine.arguments.count == 3 else {
    usage()
}

let command = CommandLine.arguments[1]
let name = CommandLine.arguments[2]

guard name.range(
    of: #"^[A-Z][A-Z0-9_]*$"#,
    options: .regularExpression
) != nil else {
    fputs("Invalid secret name\n", stderr)
    exit(2)
}

let query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword,
    kSecAttrService as String: service,
    kSecAttrAccount as String: name,
]

func trustedAccess() -> SecAccess? {
    var applications: [SecTrustedApplication] = []

    let executablePath = URL(
        fileURLWithPath: CommandLine.arguments[0]
    ).standardizedFileURL.path
    for path in [executablePath, "/usr/bin/security"] {
        var application: SecTrustedApplication?
        let status = SecTrustedApplicationCreateFromPath(path, &application)
        guard status == errSecSuccess, let application else {
            fputs(
                "Unable to trust \(path) (OSStatus \(status))\n",
                stderr
            )
            return nil
        }
        applications.append(application)
    }

    var access: SecAccess?
    let status = SecAccessCreate(
        "Agent secret: \(name)" as CFString,
        applications as CFArray,
        &access
    )
    guard status == errSecSuccess else {
        fputs(
            "Unable to create Keychain access policy (OSStatus \(status))\n",
            stderr
        )
        return nil
    }
    return access
}

func readValue() -> (OSStatus, Data?) {
    var readQuery = query
    readQuery[kSecReturnData as String] = true
    readQuery[kSecMatchLimit as String] = kSecMatchLimitOne

    var result: CFTypeRef?
    let status = SecItemCopyMatching(readQuery as CFDictionary, &result)
    return (status, result as? Data)
}

switch command {
case "get":
    let (status, value) = readValue()
    guard status == errSecSuccess, let value else {
        fputs("Keychain item not found: \(name)\n", stderr)
        exit(1)
    }
    FileHandle.standardOutput.write(value)

case "has":
    let (status, _) = readValue()
    exit(status == errSecSuccess ? 0 : 1)

case "set":
    let value = FileHandle.standardInput.readDataToEndOfFile()
    guard !value.isEmpty else {
        fputs("Secret value cannot be empty\n", stderr)
        exit(2)
    }
    guard let access = trustedAccess() else {
        exit(1)
    }

    let attributes: [String: Any] = [
        kSecValueData as String: value,
        kSecAttrLabel as String: "Agent secret: \(name)",
        kSecAttrComment as String: "Managed by ~/.dotfiles/bin/agent-secret",
        kSecAttrAccess as String: access,
    ]

    let updateStatus = SecItemUpdate(
        query as CFDictionary,
        attributes as CFDictionary
    )

    if updateStatus == errSecItemNotFound {
        var item = query
        attributes.forEach { item[$0.key] = $0.value }
        let addStatus = SecItemAdd(item as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            fputs(
                "Unable to add Keychain item (OSStatus \(addStatus))\n",
                stderr
            )
            exit(1)
        }
    } else if updateStatus != errSecSuccess {
        fputs(
            "Unable to update Keychain item (OSStatus \(updateStatus))\n",
            stderr
        )
        exit(1)
    }

default:
    usage()
}
