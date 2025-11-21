using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Json;

namespace ZoozyApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PlacesController : ControllerBase
    {
        private readonly HttpClient _httpClient;
        private readonly string _googleApiKey = "AIzaSyCxCjJKz8p4hDgYuzpSs27mCRGAmc8BFI4"; // Buraya Google API Key

        public PlacesController(IHttpClientFactory httpClientFactory)
        {
            _httpClient = httpClientFactory.CreateClient();
        }

        // Autocomplete endpoint
        [HttpGet("autocomplete")]
        public async Task<IActionResult> Autocomplete([FromQuery] string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return BadRequest(new { error = "Input is required" });

            var googleUrl = $"https://maps.googleapis.com/maps/api/place/autocomplete/json?input={input}&key={_googleApiKey}";

            try
            {
                var response = await _httpClient.GetFromJsonAsync<object>(googleUrl);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        // Details endpoint
        [HttpGet("details")]
        public async Task<IActionResult> Details([FromQuery] string place_id)
        {
            if (string.IsNullOrWhiteSpace(place_id))
                return BadRequest(new { error = "place_id is required" });

            var googleUrl = $"https://maps.googleapis.com/maps/api/place/details/json?place_id={place_id}&key={_googleApiKey}";

            try
            {
                var response = await _httpClient.GetFromJsonAsync<object>(googleUrl);
                return Ok(response);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }
}
