namespace ZoozyApi.Dtos
{
    public class GoogleLoginRequest
    {
        public string FirebaseUid { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string DisplayName { get; set; } = string.Empty;
        public string? PhotoUrl { get; set; }
        public string Provider { get; set; } = "google";
    }
}
