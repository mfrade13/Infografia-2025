using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class CharacterSelectButton : MonoBehaviour
{
    public int characterIndex; // 0 para Lunatic, 1 para Vortex
    public Text warningText;

    public void SelectCharacter()
    {
        CharacterSelectionManager.selectedCharacterIndex = characterIndex;
        warningText.gameObject.SetActive(false);

    }
}
