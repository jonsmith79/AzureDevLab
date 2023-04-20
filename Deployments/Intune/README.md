
# Intune as Code

## UNDER DEVELOPMENT

---

This template deploys:

- ***Nothing yet!***

Parameters that support changes
| Parameter | Description |
|-----------|-------------|

ToDo list:

- [ ] Manually setup Azure login with OpenID Connect (OIDC) as per [https://github.com/marketplace/actions/azure-login](https://github.com/marketplace/actions/azure-login) and [https://learn.microsoft.com/en-us/azure/active-directory/workload-identities/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#github-actions](https://learn.microsoft.com/en-us/azure/active-directory/workload-identities/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#github-actions)
- [ ] Create a Break Glass group (SG-CA-BreakGlass)
- [ ] Create a Break Glass account (Break Glass / break.glass@domain.com)
  - [ ] Assign the Break Glass account to the Azure AD Global Admin built-in role
  - [ ] Add Break Glass account into the Break Glass group
- [ ] Create a group for highly secured administrative users (SG-Admins-All)
  - [ ] Add default Azure AD admin account to he highly secured administrative users group
- [ ] Create an M365 GBL group (SG-M365-E5) [?Dynamic/Static?]
  - [ ] Assign the M365 licenses to the GBL group
  - [ ] Add Break Glass account to the GBL group (if not a dynamic group)
- [ ] Create a group for all tenant users (SG-Users-All) [?Dynamic/Static?]

>*[Markdown Cheatsheet](https://www.markdown-cheatsheet.com/)*
