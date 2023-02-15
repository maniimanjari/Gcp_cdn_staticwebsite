terraform {
  backend "gcs"{
    bucket      = "terrabukt"
    prefix      = "permissions"
  }
}
