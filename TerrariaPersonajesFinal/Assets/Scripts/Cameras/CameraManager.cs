using UnityEngine;

public class CameraManager : MonoBehaviour
{
    public static CameraManager Instance { get; private set; }

    [Header("Camara Inicial")]

    public GameObject CamaraActual;


    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
    }

    public void SwitchCamera(GameObject nuevaCamara)
    {
        if (CamaraActual != null)
            CamaraActual.SetActive(false);

        nuevaCamara.SetActive(true);
        CamaraActual = nuevaCamara;
    }
}
