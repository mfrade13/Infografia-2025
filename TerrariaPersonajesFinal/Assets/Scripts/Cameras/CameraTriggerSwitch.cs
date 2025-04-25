using UnityEngine;

public class CameraTriggerSwitch : MonoBehaviour
{
    [Header("Configuración de Cámaras")]
    public GameObject camaraIzquierda;
    public GameObject camaraDerecha;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;

        var controller = other.GetComponent<CharacterControllerBase>();
        if (controller == null) return;

        Vector2 direccion = controller.LastDirection;

        // Entrando desde la izquierda hacia la derecha
        if (CameraManager.Instance.CamaraActual == camaraIzquierda && direccion.x > 0.2f)
        {
            CameraManager.Instance.SwitchCamera(camaraDerecha);
        }
        // Entrando desde la derecha hacia la izquierda
        else if (CameraManager.Instance.CamaraActual == camaraDerecha && direccion.x < -0.2f)
        {
            CameraManager.Instance.SwitchCamera(camaraIzquierda);
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;

        var controller = other.GetComponent<CharacterControllerBase>();
        if (controller == null) return;

        Vector2 direccion = controller.LastDirection;

        // Saliendo hacia la izquierda desde la derecha
        if (CameraManager.Instance.CamaraActual == camaraDerecha && direccion.x < -0f)
        {
            CameraManager.Instance.SwitchCamera(camaraIzquierda);
        }
        // Saliendo hacia la derecha desde la izquierda
        else if (CameraManager.Instance.CamaraActual == camaraIzquierda && direccion.x > 0f)
        {
            CameraManager.Instance.SwitchCamera(camaraDerecha);
        }
    }
}
