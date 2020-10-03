resource google_compute_project_metadata_item oslogin {
  key   = "enable-oslogin"
  value = "TRUE"
}

resource google_compute_project_metadata_item oslogin_2fa {
  key   = "enable-oslogin-2fa"
  value = "TRUE"
}
