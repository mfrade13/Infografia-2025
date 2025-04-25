using UnityEngine;

public class LunaticCultistController : CharacterControllerBase
{
    public LunaticCultistController() => facingRight = false;

    [Header("Vuelo")]
    public float flySpeed = 15f;
    public float flyTimeMax = 3f;
    private float remainingFlyTime;
    private bool isFlying;
    private bool isGliding;

    [Header("Planeo")]
    public float glideFallSpeed = -4f;

    protected override void Start()
    {
        base.Start();
        remainingFlyTime = flyTimeMax;
    }

    protected override void Update()
    {
        base.Update();

        bool spacePressed = Input.GetKey(KeyCode.Space);

        if (spacePressed && remainingFlyTime > 0)
        {
            HandleFly(); // Vuelo con o sin spam
        }
        else if (!isGrounded && remainingFlyTime <= 0 && spacePressed)
        {
            HandleGlide(); // Planeo si no hay tiempo y no está en el suelo
        }
        else
        {
            HandleFall(); // Caída libre
        }


        // Restaurar el tiempo solo cuando toca el suelo
        if (isGrounded)
        {
            remainingFlyTime = flyTimeMax;
        }

        UpdateAnimations();
    }

    private void HandleFly()
    {
        isFlying = true;
        isGliding = false;

        // Gasta tiempo incluso si el espacio fue presionado poco tiempo
        remainingFlyTime -= Time.deltaTime;
        if (remainingFlyTime < 0) remainingFlyTime = 0;

        Vector2 flyDirection = Vector2.up;

        if (horizontalInput != 0)
            flyDirection += horizontalInput > 0 ? Vector2.right : Vector2.left;

        flyDirection.Normalize();
        rb.velocity = flyDirection * flySpeed;
    }

    private void HandleGlide()
    {
        isFlying = false;
        isGliding = true;

        Vector2 glideDirection = Vector2.down;

        if (horizontalInput != 0)
            glideDirection += horizontalInput > 0 ? Vector2.right : Vector2.left;

        glideDirection.Normalize();
        rb.velocity = glideDirection * Mathf.Abs(glideFallSpeed);
    }

    protected override void HandleFall()
    {
        isFlying = false;
        isGliding = false;
        // Gravedad natural
    }

    private void UpdateAnimations()
    {
        if (isFlying)
        {
            animator.Play("LunaticCultistFly");
        }
        else if (isGliding)
        {
            animator.Play("LunaticCultistPlane");
        }
        else if (!isGrounded && rb.velocity.y < 0)
        {
            animator.Play("LunaticCultistFall");
        }
        else if (Mathf.Abs(horizontalInput) > 0 && isGrounded)
        {
            animator.Play("LunaticCultistMove");
        }
        else if (isGrounded)
        {
            animator.Play("LunaticCultistStatic");
        }
    }

    protected override void Flip()
    {
        facingRight = !facingRight;
        spriteRenderer.flipX = facingRight;
    }
}
