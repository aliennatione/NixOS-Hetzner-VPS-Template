# Security Policy

## 🛡️ Supported Versions
We provide security updates for the latest stable release and the current development branch.

| Version | Supported          |
|---------|--------------------|
| 1.x     | ✅ Yes             |
| < 1.0   | ❌ No              |

## 🚨 Reporting a Vulnerability

### **Do not report security vulnerabilities through public GitHub issues.**

Instead, please report them to security@your-email.com with the subject line "Security Vulnerability Report - nixos-hetzner-vps".

### What to include in your report:
- Type of vulnerability (e.g., RCE, privilege escalation, data leak)
- Affected components (script, module, configuration)
- Steps to reproduce (if possible)
- Potential impact
- Suggested fix (if you have one)

### Response Timeline:
- Initial acknowledgment within 24 hours
- Detailed assessment within 3 business days
- Patch development timeline provided within 5 business days
- Critical vulnerabilities patched within 7 days

## 🔒 Security Best Practices

### For Users:
- Always verify script signatures before execution
- Use strong, unique passphrases for LUKS encryption
- Keep your system updated with `nixos-rebuild switch --upgrade`
- Regularly audit your SSH keys and firewall rules
- Enable ZFS snapshots and offsite backups

### For Contributors:
- Never commit secrets or credentials to the repository
- Use environment variables for sensitive data in tests
- Validate all user inputs in scripts
- Follow principle of least privilege in configurations
- Document security implications of changes

## 🔄 Disclosure Process

1. **Report received** - We acknowledge receipt
2. **Assessment** - Security team evaluates impact and severity
3. **Patch development** - Fix is developed internally
4. **Testing** - Patch is tested thoroughly
5. **Release** - Security update is released with CVE assignment if applicable
6. **Disclosure** - Advisory published with details and mitigation steps

## 📊 Security Metrics

We track the following security metrics:
- Time to patch critical vulnerabilities
- Number of security advisories per quarter
- Security test coverage percentage
- Dependency vulnerability scan results

## 🤝 Security Partnerships

We work with:
- NixOS Security Team for upstream vulnerabilities
- Hetzner Security Team for infrastructure-related issues
- Open Source Security Foundation (OSSF) for best practices

## 📞 Contact Information

**Security Team**: security@your-email.com  
**PGP Key**: [Link to your PGP key]  
**Security Advisories**: [Link to security advisories page]

---
This policy is reviewed and updated quarterly. Last updated: November 15, 2025