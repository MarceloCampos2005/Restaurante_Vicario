# Vicario 🍽️

Uma aplicação web abrangente para gestão de restauração, desenvolvida com suporte para múltiplos perfis de utilizador, pedidos *take-away*, gestão de mesas e *dashboards* analíticos.

## 🌟 Funcionalidades Principais

* **Gestão de Perfis:** Acessos dedicados e funcionais para **Cliente**, **Funcionário** e **Administrador**.
* **Pedidos Take-away:** Sistema integrado para a realização e o acompanhamento de encomendas para fora.
* **Gestão de Mesas:** Controlo de ocupação e estado das mesas dentro do estabelecimento.
* **Analítica e Faturação:** *Dashboards* para acompanhamento detalhado de faturação e análise dos pratos mais vendidos.

## 🛠️ Tecnologias Utilizadas

**Frontend:**
* HTML5, CSS3, JavaScript
* JSP (Jakarta Server Pages)

**Backend:**
* Java (Jakarta Servlet API 6.0.0)
* Gestão de dependências e *build* com **Maven**
* Processamento de dados JSON com `org.json`

**Base de Dados:**
* MariaDB (via `mariadb-java-client`)

**Infraestrutura e Deployment:**
* **Servidor de Aplicação:** Apache Tomcat 10.1.39
* **Containerização:** Docker
* **Alojamento:** Render

## 🚀 Como Executar Localmente

### Pré-requisitos
* [Java JDK](https://www.oracle.com/java/technologies/downloads/) (compatível com a API Jakarta 6.0.0)
* [Maven](https://maven.apache.org/)
* [Docker](https://www.docker.com/)

### Instalação e Execução

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/MarceloCampos2005/vicario.git](https://github.com/MarceloCampos2005/vicario.git)
   cd vicario
