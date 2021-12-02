using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteAnimation : MonoBehaviour
{
    public Sprite[] Sprites;
    public float Framrate;

    public Sprite DeathSprite;
    
    private int _idx;
    private SpriteRenderer _sr;
    private float _timer;

    void Start()
    {
        _idx = 0;
        _sr.sprite = Sprites[_idx];
    }


    void Update()
    {
        _timer += Time.deltaTime;
        if (_timer >= Framrate)
        {
            _timer -= Framrate;
            _idx = (_idx + 1) % Sprites.Length;
        }
    }
}
