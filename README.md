# sales_sample
Sales sample project

## 🚀 Guía de Inicio Rápido

Sigue estes pasos para configurar e executar o proxecto no teu contorno local.

### 1. Clonar o repositorio

```bash
git clone https://github.com/bigdatawirtz/sales_sample.git
cd sales_sample
```

---

### 2. Crear e activar o contorno virtual

**En Linux:**
```bash
python3 -m venv .venv
source .venv/bin/activate
```


---

### 3. Instalar as dependencias

Co contorno virtual activo, instala os paquetes necesarios:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

---

### 4. Executar o código Python

Para lanzar o script principal situado na carpeta `src`:

```bash
python src/tarefa1.py
```

---

### 5. Levantar a infraestrutura con Docker Compose

Para iniciar os servizos definidos en `docker-compose.yml`:

```bash
docker compose up -d
```

Para deter os servizos cando remates:

```bash
docker compose down
```

---

### 6. Executar o código SQL dentro do contedor

Para executar a carga de datos e consultas no servidor SQL


```bash
docker exec mysql-vendas sh -c 'mysql -uroot -pbigdata vendas < /sql/tarefa1.sql'
```
