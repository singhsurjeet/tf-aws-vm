#OUTPUTS

output "sg-id" {
  value = "${aws_security_group.sg.id}"
}

//output "eip" {
//  value = "${aws_eip.master.public_ip}"
//}