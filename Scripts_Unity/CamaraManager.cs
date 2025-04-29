using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamaraManager : MonoBehaviour
{
    public Camera cam1;
    public Camera cam2;

    private bool perspectiva;

    // Start is called before the first frame update
    void Start()
    {
        cam1.enabled = true;
        cam2.enabled = false;
        perspectiva = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.LeftControl))
        {
            if (perspectiva)
            {
                perspectiva = false;
                cam1.enabled = false;
                cam2.enabled = true;
            }
            else
            {
                cam1.enabled = true;
                cam2.enabled = false;
                perspectiva = true;
            }
        }


    }
}
