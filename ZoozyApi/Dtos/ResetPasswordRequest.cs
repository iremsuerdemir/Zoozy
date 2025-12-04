namespace ZoozyApi.Dtos
{
    public class ResetPasswordRequest
    {
        public string Email { get; set; } = string.Empty;
    }

    public class ResetPasswordResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public string? NewPassword { get; set; } // Sadece döndürmek için, body'de değil
    }
}
