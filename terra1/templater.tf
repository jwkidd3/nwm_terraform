data "template_file" "dev_hosts" {
  template = "${file("dev_hosts.cfg")}"
  depends_on = [
    "aws_instance.instance"
  ]
  vars {
    api_public = "${aws_instance.instance.public_ip}"
    host = "host01"
  }
}

resource "null_resource" "dev-hosts" {
  triggers {
    template_rendered = "${data.template_file.dev_hosts.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.dev_hosts.rendered}' > /home/ubuntu/ansible_jk/inventory/hosts"
  }
}
