# GaliLoc

- Aplicacion basada en CoreLocation que detecta la entrada y salida de un usuario a una sucursal perteneciente a una lista.
- La lista de sucursales se consume desde un endpoint (https://www.mocklicia.com/location/get) y se guarda en CoreData. (Respuesta mock esta incluida en este repositorio como locations.json).
- Una vez cargada la lista no la vuelve a consumir.
- Cada vez que el usuario entra o sale del radio (tambien parametrizado) de una ubicacion se envia un post a un endpoint (https://www.mocklicia.com/location/post) para registrar.
- Aclaracion ambos endpoints deben ser mockeados con apps como [Proxyman](https://proxyman.com/) o similar.


<img width="600" height="1300" alt="image" src="https://github.com/user-attachments/assets/39ce2100-c601-4cd1-9fc8-0f51c3fc2266" />

  <img width="1009" height="328" alt="image" src="https://github.com/user-attachments/assets/2027eb74-cb2d-4459-b440-2b30ba94ecfb" />
  <img width="541" height="328" alt="image" src="https://github.com/user-attachments/assets/209227f1-9dfc-442c-89be-8d2a773da16e" />
<img width="541" height="328" alt="image" src="https://github.com/user-attachments/assets/fa0ea2fc-8fae-4cdd-b6f9-48e0590f4fbe" />



  
