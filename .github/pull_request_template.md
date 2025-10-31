## Related issue(s)

- 

## Proposed Changes

- 

## Testing

This change was validated by the following observations:

-  

## Checklist

**General**
- [ ] I have deployed and validated this change
- [ ] Changelog
  - [ ] I have added my changes to CHANGELOG.md
  - [ ] No changelog entry is necessary

**If releasing a new version**
- [ ] In CHANGELOG.md, I have moved unreleased items to a newly created release section

**If a new input variable was added**
- [ ] I have added a new variable in inputs.tf with a description, added the variable to defaults.tfvars, and to ./utils/cicd/main.tf

**If the built-in stac-server version was updated**
- [ ] I have updated the `stac_server_version` default value in inputs.tf, noted a version bump in CHANGELOG.md, and updated the `STAC_SERVER_TAG` throughout ./.github/workflows
