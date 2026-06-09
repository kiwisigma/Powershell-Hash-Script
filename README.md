# 🔐 File Hash Verifier

> Verify the integrity of any file by computing and comparing its cryptographic hash — available as both a **PowerShell GUI tool** (Windows) and a **Bash CLI tool** (Linux/Mac).

---

## 🧠 Why This Exists

When you download a file from the internet — an ISO, an installer, a binary — you can't always trust that it arrived intact or unmodified. Hash verification lets you confirm:

- The file wasn't **corrupted** in transit
- The file wasn't **tampered with** or swapped for a malicious version

This tool makes that check fast and simple.

---

## 🖥️ PowerShell Version (Windows GUI)

A Windows Forms GUI that walks you through the process — no command line needed.

**How it works:**
1. A file picker opens — select the file you want to verify
2. A dialog lets you choose the hash algorithm
3. The computed hash is displayed and compared against your expected hash
4. Pass or fail result shown in green or red

**Run it:**
```powershell
# Without an expected hash (just compute it)
.\powershell-hash-script.ps1

# With an expected hash to compare against
.\powershell-hash-script.ps1 -hash "ABC123..."
```

**Supported algorithms:**

| Algorithm | Notes |
|-----------|-------|
| SHA256 | Recommended — most common for downloads |
| SHA512 | Stronger, used for high-security verification |
| SHA384 | Less common |
| SHA1 | Legacy — avoid for security-critical use |
| MD5 | Legacy — avoid for security-critical use |
| MACTripleDES | Legacy |
| RIPEMD160 | Legacy |

---

## 🐧 Bash Version (Linux / Mac CLI)

A hardened shell script equivalent for non-Windows systems.

**Usage:**
```bash
# Compute hash only
./compare-hash.sh <file> [algorithm]

# Compute and compare against expected hash
./compare-hash.sh <file> sha256 "abc123..."
```

**Example:**
```bash
# Verify a downloaded ISO
./compare-hash.sh ubuntu-24.04.iso sha256 "a435f6f393dda581172490eda9f683c32e495158a780b5a1de422ee77d98e909"

File:      ubuntu-24.04.iso
Algorithm: sha256
Actual:    a435f6f393dda581172490eda9f683c32e495158a780b5a1de422ee77d98e909
Expected:  a435f6f393dda581172490eda9f683c32e495158a780b5a1de422ee77d98e909

✔ The hash values match
```

**Supported algorithms:** `sha256` `sha512` `sha384` `sha1` `md5`

---

## 📁 Structure

```
├── powershell/
│   └── powershell-hash-script.ps1   # Windows GUI tool
└── bash/
    └── compare-hash.sh              # Linux/Mac CLI tool
```

---

## 🛡️ Security Notes

- Both scripts **normalize hashes** before comparison (strips whitespace, case-insensitive) to prevent false mismatches from copy-paste formatting
- The Bash script uses `set -euo pipefail` to prevent silent failures
- Neither script makes network calls — everything runs locally

---

*Built as a practical file integrity tool with cross-platform support.*
