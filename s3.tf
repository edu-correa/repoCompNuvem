## crianção de bucket s3
resource "aws_s3_bucket" "aula1" {
  tags = {
    Name = "arquivos"
  }

  # impedir que o bucket seja excluído caso tenha objetos
  force_destroy = false  # o padrão é false

  # habilitar o bloqueio de objetos (se alguém estive lendo, fica bloqueado). 
  object_lock_enabled = false # O padrão é false
}

## Configuração de acesso público ao bucket
resource "aws_s3_bucket_public_access_block" "bucket_acessos" {
  bucket = aws_s3_bucket.aula1.id

  # configurações para acesso público via ACL - Access Control Lists (se true pode permitir  que outras contas AWS tenhamn acesso)
  block_public_acls   = false # o padrão é false  

  # configurações para acesso público via bucket policy (se true pode permitir que qualquer pessoa tenha acesso)
  block_public_policy = false # o padrão é false
}