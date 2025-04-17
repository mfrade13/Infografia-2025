using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Piso : MonoBehaviour
{

    public GameObject cazador;
    private Transform cazador_t;
    private Transform mi_transformada;

    // Start is called before the first frame update
    void Start()
    {
        mi_transformada = GetComponent<Transform>();
        cazador_t = cazador.GetComponent<Transform>();
        Debug.Log(cazador);
        Debug.Log("Ecalas del cazador son " +  cazador_t.localScale);
        Debug.Log("Mis escalas son: " + mi_transformada.localScale);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
