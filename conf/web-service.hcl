service {
  name = "web",
  port = 80,
  check {
    args = ["curl", "localhost"],
    interval = "3s"
  }
}
