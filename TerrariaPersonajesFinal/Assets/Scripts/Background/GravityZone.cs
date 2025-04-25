using UnityEngine;

public class GravityZone : MonoBehaviour
{
    [Header("Gravedad")]
    public float nuevaGravedad = 0.5f; // 0 para sin gravedad (espacio)
    public float gravedadAnterior = 3f;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            Rigidbody2D rb = other.GetComponent<Rigidbody2D>();
            if (rb != null)
            {
                gravedadAnterior = rb.gravityScale;
                rb.gravityScale = nuevaGravedad;
            }
        }
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            Rigidbody2D rb = other.GetComponent<Rigidbody2D>();
            if (rb != null)
            {
                rb.gravityScale = gravedadAnterior;
            }
        }
    }
}
