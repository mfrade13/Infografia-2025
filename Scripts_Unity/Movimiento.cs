using System.Collections;
using System.Collections.Generic;
using UnityEngine;


enum nombres {
    Jassir,
    Miguel, 
}

public class Movimiento : MonoBehaviour
{
    private int numero = 4;
    // private float peso = 34.01f;
    public string texto = "Cazador";
    public bool isAlive = true;
    // private char letra = 'a';
    // private double numero_double = 1247979872.23;
    // private long numero_grande = 12412421342;
    // byte bit = 1;
    // ushort usnamered = 34;
    public float velocidad;
    public float salto;
    public Transform piso_transform;
    private Animator anim;
    private Rigidbody2D rb;
    private bool canJump;



    public int Sumar(int a, int b)
    {
        return a + b;
    }

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("El nombre de este objeto es " + texto);
        Debug.Log(Sumar(numero, 5));
        Debug.Log(piso_transform);
        Debug.Log(piso_transform.localPosition);
        anim = GetComponent<Animator>();
        rb = GetComponent<Rigidbody2D>();
        canJump = true;
    }

    // Update is called once per frame
    void Update()
    {

        float movimiento_x = Input.GetAxis("Horizontal");
        // Debug.Log(movimiento_x);

        anim.SetFloat("move", Mathf.Abs(movimiento_x));
        transform.Translate(new Vector3(movimiento_x * velocidad * Time.deltaTime, 0, 0));

        if (Input.GetKey(KeyCode.Space))
        {
            Debug.Log("Saltar");
            rb.AddForce(new Vector2(0, salto)  * Time.deltaTime  , ForceMode2D.Impulse);
            canJump = false;
        }
        anim.SetBool("jump", !canJump);

        //if (isAlive)
        //{
        //    Debug.Log("Nuestro cazador esta vivo ");
        //    transform.localPosition = new Vector3( UnityEngine.Random.value * 10, transform.localPosition.y, 0 );
        //}
    }

    void OnCollisionEnter2D(Collision2D collision)
    {
        Debug.Log("Iniciando colision con " +   collision.gameObject);
        canJump = true;
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        
    }

}
