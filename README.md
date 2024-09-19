## README - Gestión de libros con Flutter y Laravel

### Requisitos Previos

1. **Backend**: Laravel 9+ con Sanctum instalado.
2. **Frontend**: Proyecto en Flutter.
3. **Base de datos**: MySQL configurado y corriendo.

### Instalación del Backend (Laravel)

1. **Clonar el repositorio**:

   ```bash
   git clone <URL_del_Repositorio>
   cd bookstore-backend
   ```

2. **Instalar dependencias**:

   Asegúrate de tener Composer instalado. Luego, corre:

   ```bash
   composer install
   ```

3. **Configurar las variables de entorno**:

   Copia el archivo `.env.example` y renómbralo a `.env`. Luego, abre el archivo y configura las variables de conexión de la base de datos, así como otros parámetros necesarios.

   ```bash
   cp .env.example .env
   ```

   Configura los siguientes parámetros en el archivo `.env`:

   ```bash
   DB_DATABASE=bookstore_bd
   DB_USERNAME=tu_usuario
   DB_PASSWORD=tu_contraseña
   ```

4. **Generar la clave de la aplicación**:

   ```bash
   php artisan key:generate
   ```

5. **Ejecutar las migraciones y seeders**:

   Para crear las tablas y poblar la base de datos con datos iniciales (autores, libros, géneros, etc.), ejecuta:

   ```bash
   php artisan migrate
   php artisan db:seed
   ```

6. **Levantar el servidor**:

   Inicia el servidor de Laravel en tu entorno local:

   ```bash
   php artisan serve
   ```

   Esto iniciará el backend en `http://127.0.0.1:8000`.

### Instalación del Frontend (Flutter)

1. **Clonar el repositorio de Flutter**:

   ```bash
   git clone <URL_del_Repositorio_Frontend>
   cd bookstore-frontend
   ```

2. **Actualizar la configuración de la API**:

   En el archivo de configuración de Flutter (`assets/cfg`), asegúrate de que la URL de la API apunte al servidor local de Laravel:

   ```json
   {
     "base_url": "http://127.0.0.1:8000/api/",
     "api_base_url": "http://127.0.0.1:8000/api/"
   }
   ```

3. **Instalar dependencias**:

   Asegúrate de tener Flutter instalado. Luego, corre:

   ```bash
   flutter pub get
   ```

4. **Ejecutar la aplicación**:

   Conecta tu dispositivo o emulador Android/iOS, o usa Chrome para la web, y luego ejecuta:

   ```bash
   flutter run -d chrome
   ```

### Acceso al sistema

- **Admin**:
    - Correo: `admin@example.com`
    - Contraseña: `123456`

- **Operativo**:
    - Correo: `user@example.com`
    - Contraseña: `123456`

### Funcionalidades Principales

1. **Login**:
    - El usuario puede iniciar sesión como administrador o como operativo.

2. **Gestión de Libros**:
    - **CRUD Completo**: Los usuarios con rol de administrador pueden crear, editar, actualizar y eliminar libros en el sistema.

### Versiones Utilizadas

- **Laravel**: 9.x
- **Flutter**: 3.x
- **PHP**: 8.x
- **MySQL**: 8.x
- **Composer**: 2.x

### Migraciones y Seeders

Si por alguna razón las tablas no existen o se requiere reinstalar, puedes ejecutar las migraciones y los seeders de nuevo con los siguientes comandos:

```bash
php artisan migrate
```

```bash
php artisan db:seed
```

Este comando reiniciará la base de datos y aplicará los datos iniciales (usuarios, libros, autores, géneros, etc.).

---

**Nota**: Asegúrate de que el servidor de Laravel esté corriendo antes de intentar acceder a la aplicación Flutter.

¡Disfruta usando el sistema de gestión de libros!