using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class NextScene : MonoBehaviour
{
    public Toggle vortexToggle;
    public Toggle lunaticToggle;
    public Text warningText; 


    public void StartGame()
    {
        if (vortexToggle.isOn || lunaticToggle.isOn)
        {
            SceneManager.LoadScene("Game");
            
        }
        else
        {
            warningText.text = "Selecciona un personaje antes de continuar.";
            warningText.gameObject.SetActive(true);
        }
    }
}
