// Sends your public key to the instance
resource "aws_key_pair" "project-region-key-pair" {
  key_name = "${var.project_name}-region-key-pair"
  public_key = "${file(var.public_key_path)}"
}

output "project_region_key_pair_id" {
  value = aws_key_pair.project-region-key-pair.id
}