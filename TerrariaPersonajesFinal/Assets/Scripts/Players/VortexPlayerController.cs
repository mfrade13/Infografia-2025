using UnityEngine;

public class VortexPlayerController : CharacterControllerBase
{
    public VortexPlayerController() => facingRight = true;

    [Header("Aceleración")]
    public float acceleration = 10f;
    public float maxSpeed = 20f;

    [Header("Salto")]
    public float jumpForce = 12f;
    public int maxJumps = 2;
    private int jumpCount;

    // Animators por pieza
    private Animator leftArmAnimator;
    private Animator rightArmAnimator;
    private Animator jetPackAnimator;
    private Animator legsAnimator;

    // SpriteRenderers por caída
    private SpriteRenderer leftArmSprite;
    private SpriteRenderer rightArmSprite;
    private SpriteRenderer leftArmFallSprite;
    private SpriteRenderer rightArmFallSprite;

    // Flags de estado
    private bool isRunning;
    private bool isJumping;
    private bool isFalling;
    private bool isIdle;

    protected override void Start()
    {
        base.Start();

        leftArmAnimator = transform.Find("LeftArm").GetComponent<Animator>();
        rightArmAnimator = transform.Find("RightArm").GetComponent<Animator>();
        jetPackAnimator = transform.Find("JetPack").GetComponent<Animator>();
        legsAnimator = transform.Find("Legs").GetComponent<Animator>();

        leftArmSprite = transform.Find("LeftArm").GetComponent<SpriteRenderer>();
        rightArmSprite = transform.Find("RightArm").GetComponent<SpriteRenderer>();
        leftArmFallSprite = transform.Find("LeftArmFall").GetComponent<SpriteRenderer>();
        rightArmFallSprite = transform.Find("RightArmFall").GetComponent<SpriteRenderer>();

        // Desactivar los sprites de caída al inicio
        if (leftArmFallSprite != null) leftArmFallSprite.enabled = false;
        if (rightArmFallSprite != null) rightArmFallSprite.enabled = false;
    }

    protected override void Update()
    {
        base.Update();

        isIdle = isGrounded && Mathf.Abs(rb.velocity.x) < 0.1 && Mathf.Abs(rb.velocity.y) < 0.1;

        HandleJump();

        HandleFall();

        if (isGrounded)
            jumpCount = 0;

        if (isIdle)
        {
            ResetAnimator(legsAnimator);
            ResetAnimator(leftArmAnimator);
            ResetAnimator(rightArmAnimator);
            ResetAnimator(jetPackAnimator);
        }
    }

    protected override void Move()
    {
        float targetSpeed = horizontalInput * maxSpeed;
        float speedDiff = targetSpeed - rb.velocity.x;
        float movement = speedDiff * acceleration;

        isRunning = Mathf.Abs(rb.velocity.x) > 0f && Mathf.Abs(rb.velocity.y) < 0.1f && isGrounded;
        SetBoolInMultiple("isRunning", isRunning, legsAnimator, leftArmAnimator, rightArmAnimator);
        if (horizontalInput != 0)
        {
            rb.AddForce(new Vector2(movement, 0f));

            if (Mathf.Abs(rb.velocity.x) > maxSpeed)
                rb.velocity = new Vector2(Mathf.Sign(rb.velocity.x) * maxSpeed, rb.velocity.y);
        }
        else
        {
            rb.velocity = new Vector2(0f, rb.velocity.y);
        }
        SetBoolInMultiple("isRunning", isRunning, legsAnimator, leftArmAnimator, rightArmAnimator);
    }

    private void HandleJump()
    {
        isJumping = Input.GetKeyDown(KeyCode.Space) && jumpCount < (maxJumps - 1);

        if (isJumping)
        {
            rb.velocity = new Vector2(rb.velocity.x, 0f); // Reinicia velocidad Y antes del salto
            rb.AddForce(Vector2.up * jumpForce, ForceMode2D.Impulse);
            jumpCount++;
        }

        SetBoolInMultiple("isJumping", isJumping, legsAnimator, leftArmAnimator, rightArmAnimator, jetPackAnimator);
    }

    protected override void HandleFall()
    {
        isFalling = !isGrounded && rb.velocity.y < -0.1f;
        if (isFalling)
        {
            // Activar sprites de caída y desactivar sprites normales
            if (leftArmSprite != null) leftArmSprite.enabled = false;
            if (rightArmSprite != null) rightArmSprite.enabled = false;
            if (leftArmFallSprite != null) leftArmFallSprite.enabled = true;
            if (rightArmFallSprite != null) rightArmFallSprite.enabled = true;
        }
        else
        {
            // Desactivar sprites de caída y activar sprites normales
            if (leftArmSprite != null) leftArmSprite.enabled = true;
            if (rightArmSprite != null) rightArmSprite.enabled = true;
            if (leftArmFallSprite != null) leftArmFallSprite.enabled = false;
            if (rightArmFallSprite != null) rightArmFallSprite.enabled = false;
        }
        SetBoolInMultiple("isFalling", isFalling, legsAnimator, jetPackAnimator);
    }


    private void SetBoolInMultiple(string parameter, bool value, params Animator[] animators)
    {
        foreach (var animator in animators)
            if (animator != null)
                animator.SetBool(parameter, value);
    }

    private void ResetAnimator(Animator animator)
    {
        if (animator != null)
        {
            animator.Play("Empty", 0);
        }
    }

    protected override void Flip()
    {
        facingRight = !facingRight;

        Vector3 scale = transform.localScale;
        float originalScaleX = Mathf.Abs(scale.x);

        scale.x = facingRight ? originalScaleX : -originalScaleX;
        transform.localScale = scale;
    }
}