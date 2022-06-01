# APIM root module

Deploys all the infrastructure required by the subsequent terraform root modules. The resources in this module are deployed once per environment at most - such as,

- An API Management instance
- Key Vault
- CDN Profile
- VNET
