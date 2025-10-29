# 🕒 PD Hours Control

## ⚙️ (FrontEnd - Flutter)

### 1️⃣ Instale as dependências:
flutter pub get

### 2️⃣ Execute no navegador (Web):
flutter run -d chrome

### 3️⃣ Execute no emulador Android:
flutter run -d emulator-5554

Ou em um dispositivo físico:
flutter run


---


## 🧩 Configuração do banco

Crie o banco:
CREATE DATABASE pd_hours;
USE pd_hours;

Crie as tabelas:
CREATE TABLE squads (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  estimatedHours DOUBLE NOT NULL,
  squadId INT,
  FOREIGN KEY (squadId) REFERENCES squads(id)
);

CREATE TABLE reports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255),
  employeeId INT,
  spentHours DOUBLE,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (employeeId) REFERENCES employees(id)
);

---


# ⚙️ BACKEND (Node.js)

## ▶️ Executando o backend

Instale as dependências:
npm install

Rode o servidor:
node src/server.js

Servidor ativo em:
http://localhost:3000

---

## Criar um arquivo .env na pasta /backend
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=<SUA_SENHA>
DB_NAME=pd_hours
PORT=3000

---

## 🧠 Endpoints principais

| Método | Rota | Descrição |
|--------|------|------------|
| POST | /squad | Cria uma nova squad |
| GET | /squad | Lista squads |
| POST | /employee | Cria employee |
| GET | /employee | Lista employees |
| POST | /report | Lança hora |
| GET | /report/squad-hours | Lista horas por membro |
| GET | /report/squad-total | Total de horas |
| GET | /report/squad-average | Média por dia |

---

