using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Game : MonoBehaviour
{
    public Transform[] Lines;
    public GameObject Player;
    
    private bool _Moving;
    private int _LineIdx;
    // Start is called before the first frame update
    void Start()
    {
        _LineIdx = Lines.Length/2;
        Player.transform.position = Lines[_LineIdx].position;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
