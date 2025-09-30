variable "default_password" {
    type = string
    description = "Variable for default_password secret, must be defined in pipeline or env var as TF_VAR_default_password"
    default = null
}