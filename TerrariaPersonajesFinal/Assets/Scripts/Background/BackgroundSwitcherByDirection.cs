using UnityEngine;
using System.Collections;

public class BackgroundSwitcherByDirection : MonoBehaviour
{
    [Header("Fondos Verticales")]
    public GameObject fondoInferior;
    public GameObject fondoSuperior;

    [Header("Fondos Horizontales")]
    public GameObject fondoIzquierdo;
    public GameObject fondoDerecho;

    public float fadeDuration = 1f;

    private Coroutine transicionActiva = null;

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;

        var controller = other.GetComponent<CharacterControllerBase>();
        if (controller == null) return;

        // Transición en dirección de entrada
        RealizarTransicion(controller.LastDirection);
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        if (!other.CompareTag("Player")) return;

        var controller = other.GetComponent<CharacterControllerBase>();
        if (controller == null) return;

        // Transición en dirección de salida
        RealizarTransicion(controller.LastDirection);
    }

    private void RealizarTransicion(Vector2 direccion)
    {
        GameObject fondoActual = null;
        GameObject fondoNuevo = null;

        if (direccion.y > 0.1f)
        {
            fondoActual = fondoInferior;
            fondoNuevo = fondoSuperior;
        }
        else if (direccion.y < -0.1f)
        {
            fondoActual = fondoSuperior;
            fondoNuevo = fondoInferior;
        }
        else if (direccion.x > 0.1f)
        {
            fondoActual = fondoIzquierdo;
            fondoNuevo = fondoDerecho;
        }
        else if (direccion.x < -0.1f)
        {
            fondoActual = fondoDerecho;
            fondoNuevo = fondoIzquierdo;
        }

        if (fondoActual != null && fondoNuevo != null)
        {
            if (transicionActiva != null)
                StopCoroutine(transicionActiva);

            transicionActiva = StartCoroutine(Fade(fondoActual, fondoNuevo));
        }
    }

    private IEnumerator Fade(GameObject fondoActual, GameObject fondoNuevo)
    {
        // Activa ambos para empezar la transición
        fondoActual.SetActive(true);
        fondoNuevo.SetActive(true);

        SpriteRenderer srActual = fondoActual.GetComponent<SpriteRenderer>();
        SpriteRenderer srNuevo = fondoNuevo.GetComponent<SpriteRenderer>();

        float alphaActual = srActual.color.a;
        float alphaNuevo = srNuevo.color.a;
        float elapsed = 0f;

        while (elapsed < fadeDuration)
        {
            float t = elapsed / fadeDuration;
            srActual.color = new Color(1, 1, 1, Mathf.Lerp(alphaActual, 0f, t));
            srNuevo.color = new Color(1, 1, 1, Mathf.Lerp(alphaNuevo, 1f, t));

            elapsed += Time.deltaTime;
            yield return null;
        }

        // Finaliza la transición con valores exactos
        srActual.color = new Color(1, 1, 1, 0f);
        srNuevo.color = new Color(1, 1, 1, 1f);

        // Apaga el fondo que ya no se ve
        fondoActual.SetActive(false);

        transicionActiva = null;
    }

}
