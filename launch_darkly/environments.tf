resource "launchdarkly_environment" "environment" {
  name  = var.environment_name
  key   = var.environment_name
  color = "0000ff"
  tags  = ["terraform", "development", var.environment_name]

  project_key = data.launchdarkly_project.tsw.key
}
