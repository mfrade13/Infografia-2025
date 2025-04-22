using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class level_manager : MonoBehaviour
{

    public GameObject chems;
    public Transform spawingPosition;
    private GameObject enemy;

    // Start is called before the first frame update
    void Start()
    {
        enemy = Instantiate(chems, spawingPosition.position, Quaternion.identity);
        enemy.GetComponent<Transform>().localScale = new Vector3(0.2f, 0.2f, 0.2f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ChangeScene()
    {
        SceneManager.LoadScene(1);
    }

}
