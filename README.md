# Buenos Bytes 👾
Te saludan Santiago Nihany, Tomás Ward y Luz Alba Posse 👋 
# Te damos la bienvenida a Deep 📚
👉 Deep es la primer editorial descentralizada. Buscamos cambiar la forma en que los autores independientes publican sus libros

Ahora, los autores pueden conectarse directamente con los lectores y viceversa. 

No hay intermediarios que decidan qué libros se publican y cuáles no. Los lectores son quienes deciden qué contenido merece ser publicado y los autores tienen la libertad de crear sin restricciones.

---
# Instalación 💻

Para correr Deep, es importante tener en cuenta que se necesita tener instalado flutter (https://docs.flutter.dev/get-started/install). A su vez, recomendamos el enviroment de Android Studio para ejecutarlo.

1. Instalar la última actualización de Flutter SDK
2. Hacer run de flutter doctor en terminal para verificar lo instalado
3. En caso de no tener Android Studio, instalarlo (https://developer.android.com/studio?gclid=CjwKCAjwrJ-hBhB7EiwAuyBVXZ5yAXmnWT55KxRd71nAxPU3wCXM26wa0lkxpvzRAh1aWkgh215T3RoCYngQAvD_BwE&gclsrc=aw.ds)
4. Instalar un emulador de Android (recomendado)

### Algunas consideraciones 👀

- Las dependencias necesarias para correr la Dapp ya se encuentran en pubspec.yaml.
- Utilizamos hard-coded public y private keys para registrarte con un wallet de prueba. Se integrará con MetaMask para firmar las transacciones automaticamente en un futuro.
- Podes modificar esas keys para logearte con tu propio Wallet. Cambiar en `Web3Manager.dart`.
- Utilizamos Sepolia TestNet. Si conectás tu propio Wallet, no te olvides de switchearte a Sepolia para poder realizar transacciones.
- Considerar que la TestNet es puede funcionar lentamente.

---
# Stack Tecnológico 🤓

Desarrollamos una DApp utilizando: 
- *Flutter*
- *Solidity* 
- *Hardhat*

---

