resource google_compute_project_default_network_tier networktier {
  network_tier = "STANDARD" # Cheaper AU Egress $0.19/GB > $0.12/GB
}
