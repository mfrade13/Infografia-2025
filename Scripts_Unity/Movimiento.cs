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
    public Transform piso_transform;
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
    }

    // Update is called once per frame
    void Update()
    {

        float movimiento_x = Input.GetAxis("Horizontal");
        // Debug.Log(movimiento_x);

        transform.Translate(new Vector3(movimiento_x * velocidad, 0, 0));

        //if (isAlive)
        //{
        //    Debug.Log("Nuestro cazador esta vivo ");
        //    transform.localPosition = new Vector3( UnityEngine.Random.value * 10, transform.localPosition.y, 0 );
        //}
    }
}
