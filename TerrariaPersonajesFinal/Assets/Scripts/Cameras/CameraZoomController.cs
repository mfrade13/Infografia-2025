using UnityEngine;
using Cinemachine;

public class CameraZoomController : MonoBehaviour
{
    public CinemachineVirtualCamera virtualCamera;

    [Header("Zoom Settings")]
    public float zoomSpeed = 2f;
    public float minZoom = 3f;
    public float maxZoom = 10f;

    private CinemachineFramingTransposer transposer;

    private void Start()
    {
        if (virtualCamera == null)
            virtualCamera = GetComponent<CinemachineVirtualCamera>();

        transposer = virtualCamera.GetCinemachineComponent<CinemachineFramingTransposer>();
    }

    private void Update()
    {
        float scrollInput = Input.GetAxis("Mouse ScrollWheel");

        if (scrollInput != 0f && transposer != null)
        {
            float newZoom = virtualCamera.m_Lens.OrthographicSize - scrollInput * zoomSpeed;
            virtualCamera.m_Lens.OrthographicSize = Mathf.Clamp(newZoom, minZoom, maxZoom);
        }
    }
}
