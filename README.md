# Práctica 2.4 - Despliegue de WordPress en AWS EC2

Estado: **Avance parcial**.

Ya tengo subidos los archivos de configuración y los scripts para instalar y poner en marcha WordPress.

---

## Lo que ya está hecho

* **`.gitignore`**
  Sirve para que Git no suba contraseñas ni copias de seguridad 

* **`conf/`**
  puerto 80 y 443 con el certificado autofirmado

* **`htaccess/`**
  para proteger archivos sensibles, dejar entrar a la administración solo desde mi IP y activar URLs limpias.

* **`scripts/`**
  `.env.example`, `install_lamp.sh`, `setup_https.sh`, `deploy_wordpress_root_directory.sh` y `deploy_wordpress_own_directory.sh` son los scripts que llevo hechos .

---

## Qué me toca hacer el próximo día

### 1. Preparar mi archivo `.env` en la máquina
* La máquina en AWS ya está creada. Solo tengo que conectarme a ella por su IP elástica.
* Crear `scripts/.env` copiando `.env.example` y poner mis datos reales (base de datos, usuario, contraseña, mi IP elástica y mi IP pública).
* es importante tener en cuenta que este archivo no le debo subir a git , es privado.

---

### 2. Instalar todo y probar WordPress (Parte A)
* Ejecutar `install_lamp.sh`, `setup_https.sh` y el script de despliegue que elija.
* Entrar en `https://MI_IP_ELASTICA` y terminar de instalar WordPress.
* Activar los enlaces permanentes , activar un plugin y crear dos entradas.
* Comprobar que al pedir `wp-config.php` o entrar a `wp-login.php` desde otra red sale error `403`.

---

### 3. Pasar mi WordPress a la máquina de mi compañero (Parte B)
* Crear y subir `backup_wordpress.sh` y `restore_wordpress.sh`.
* Intercambiar claves SSH con mi compañero para poder enviarnos archivos.
* Crear el paquete con mi copia y mandarlo por `scp` a su máquina.
* Que él ejecute `restore_wordpress.sh` en su máquina y comprobar que ve mi contenido sin enlaces apuntando a mi IP.
* Al terminar, borrar los paquetes de copia de las dos máquinas porque llevan datos de usuarios.

---

### 4. Terminar el README y entregar
* Responder las 6 preguntas del apartado B4.
* Poner las capturas que pide la tabla del final de la práctica.
* Revisar que no haya ninguna contraseña por ahi perdida.
