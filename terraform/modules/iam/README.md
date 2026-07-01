# Módulo: iam

**Finalidade:** roles de **privilégio mínimo** para o App Runner, incluindo leitura restrita
de segredos específicos.

**Quando usar:** sempre que o serviço precisar de permissões AWS em runtime.

**Como evoluir:** adicionar uma *access role* separada para pull de imagem privada (DockerHub/ECR);
granular por serviço. Nunca usar `Resource: "*"` amplo. Ver `docs/standards/security.md`.
