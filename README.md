# 🚀 Azure Function - Mover blobs entre storages

Este proyecto implementa una **Azure Function** en Node.js que detecta un archivo subido a un contenedor de un **Storage de origen** y lo mueve automáticamente a un contenedor en un **Storage de destino**.

La infraestructura (storages, contenedores y function app) se despliega usando **Terraform**.

---

## 📂 Estructura del proyecto

---

├── mover-archivos-function/ # Código de la Azure Function

│ ├── function.json

│ ├── index.js

│ ├── package.json

│ ├── package-lock.json

│ └── host.json

├── terraform/ # Infraestructura como código

│ ├── main.tf

│ ├── variables.tf

│ ├── outputs.tf

│ └── terraform.tfstate # (Ignorado en git)

├── .gitignore

└── README.md

--

## 🛠️ Requisitos previos

- [Azure CLI](https://learn.microsoft.com/es-es/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Azure Functions Core Tools](https://learn.microsoft.com/es-es/azure/azure-functions/functions-run-local)
- Node.js (v18 recomendado)

---

## 🚧 Despliegue de la infraestructura

1. **Iniciar Terraform**

bash
cd terraform
terraform init
terraform apply -auto-approve

---

## Esto creará:
+Grupo de recursos
+Storage de origen (con contenedor origen)
+Storage de destino (con contenedor destino)
+Azure Function App

⚙️ Configuración de la Function
Instalar dependencias

cd mover-archivos-function
npm install

## Configurar las variables de entorno en Azure

az functionapp config appsettings set \
  --name func-mover-archivos \
  --resource-group rg-vmataloni \
  --settings "DEST_STORAGE_CONNECTION=<connection-string-del-destino>"
El AzureWebJobsStorage se configura automáticamente por Terraform.

**Publicar la función**
func azure functionapp publish func-mover-archivos

🧪 Prueba
Subir un archivo al contenedor origen del storage de origen:
az storage blob upload \
  --account-name <storage-origen-name> \
  --container-name origen \
  --name test3.txt \
  --file ./test3.txt \
  --account-key <clave-storage-origen>

**Si todo está configurado correctamente:

El archivo será detectado por la Function.

Se moverá automáticamente al contenedor destino del storage de destino.**


