using UnityEngine;

public class PlayerSpawner : MonoBehaviour
{
    public GameObject[] playerPrefabs; // 0 = Lunatic, 1 = Vortex

    void Start()
    {
        int index = CharacterSelectionManager.selectedCharacterIndex;
        Instantiate(playerPrefabs[index], transform.position, Quaternion.identity);
    }
}
