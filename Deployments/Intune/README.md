
# Intune as Code

## UNDER DEVELOPMENT

---

This template deploys:

- A Break Glass group (e.g. SG-CA-BreakGlass)
- A Break Glass account (e.g. Break Glass / break.glass@domain.com)
  - Adds the Break Glass account into the Break Glass group
  - Assign the Break Glass account to the Global Admin role

Parameters that support changes
| Parameter | Description |
|-----------|-------------|
| azGroupPrefix | A group prefix for any group, (e.g. "SG" for 'SG-GroupName'). |
| azBreakGlassGroupName | A name for the Break Glass group to that will be used for Conditional Access exclusions (e.g. "CA-BreakGlass"). |
| azBreakGlassGroupDescription | A brief description for the group (e.g. "Break Glass Group for Azure Conditional Access Policies"). |
| azBreakGlassAccountDisplayName | The display name for the Break Glass account (e.g. "Break Glass"). |
| azBreakGlassAccountUPN | The UPN for the Break Glass Acount, note the domain is **not** dynamic (e.g. "Break.Glass@domain.com"). |
| azBreakGlassAccountPwd | The password for the Break Glass admin, ideally pulled from secrets (e.g. ${{ secrets.ADMIN_PASSWORD }}). |
| azGARoleDefinitionId | Role definition ID to assign to Break Glass (e.g. Global Admin = "62e90394-69f5-4237-9190-012177145e10"). |

ToDo list:

- [x] Manually setup Azure login with OpenID Connect (OIDC) as per [https://github.com/marketplace/actions/azure-login](https://github.com/marketplace/actions/azure-login) and [https://learn.microsoft.com/en-us/azure/active-directory/workload-identities/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#github-actions](https://learn.microsoft.com/en-us/azure/active-directory/workload-identities/workload-identity-federation-create-trust?pivots=identity-wif-apps-methods-azp#github-actions)
- [x] Create a Break Glass group (SG-CA-BreakGlass)
- [x] Create a Break Glass account (Break Glass / break.glass@domain.com)
  - [x] Assign the Break Glass account to the Azure AD Global Admin built-in role
  - [x] Add Break Glass account into the Break Glass group
- [ ] Create a group for highly secured administrative users (SG-Admins-All)
  - [ ] Add default Azure AD admin account to he highly secured administrative users group
- [ ] Create an M365 GBL group (SG-M365-E5) [?Dynamic/Static?]
  - [ ] Assign the M365 licenses to the GBL group
  - [ ] Add Break Glass account to the GBL group (if not a dynamic group)
- [ ] Create a group for all tenant users (SG-Users-All) [?Dynamic/Static?]

>*[Markdown Cheatsheet](https://www.markdown-cheatsheet.com/)*
