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

    private bool _dead = false;
    void Start()
    {
        _sr = GetComponentInChildren<SpriteRenderer>();
        _idx = 0;
        _sr.sprite = Sprites[_idx];
    }


    void Update()
    {
        if (_dead) return;
        _timer += Time.deltaTime;
        if (_timer >= Framrate)
        {
            _timer -= Framrate;
            _idx = (_idx + 1) % Sprites.Length;
            _sr.sprite = Sprites[_idx];
        }
    }

    public void Kill()
    {
        _dead = true;
        _sr.sprite = DeathSprite;
    }
}
