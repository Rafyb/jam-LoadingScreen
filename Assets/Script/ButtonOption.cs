using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonOption : MonoBehaviour
{
    
    public GeneralScript generalScript;

    public GameObject mainMenu;


    public void Play()
    {

        generalScript.go = true;
        mainMenu.SetActive(false);
    }

    
    public void Option()
    {
        
    }

    public void Quit()
    {
        Application.Quit();
    }


}
