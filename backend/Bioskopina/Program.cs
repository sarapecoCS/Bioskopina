using Bioskopina.Filters;
using Bioskopina.Services;
using Bioskopina;
using DotNetEnv;
using Bioskopina.Services.Database;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Stripe;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddTransient<IBioskopinaService, BioskopinaService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IRoleService, RoleService>();
builder.Services.AddTransient<IUserRoleService, UserRoleService>();
builder.Services.AddTransient<IListService, ListService>();
builder.Services.AddTransient<IGenreService, GenreService>();
builder.Services.AddTransient<IWatchlistService, WatchlistService>();
builder.Services.AddTransient<IBioskopinaListService, BioskopinaListService>();
builder.Services.AddTransient<IBioskopinaWatchlistService, BioskopinaWatchlistService>();
builder.Services.AddTransient<IGenreBioskopinaService, GenreBioskopinaService>();
builder.Services.AddTransient<IPostService, PostService>();
builder.Services.AddTransient<ICommentService, CommentService>();
builder.Services.AddTransient<IPreferredGenreService, PreferredGenreService>();
builder.Services.AddTransient<IQAcategoryService, QAcategoryService>();
builder.Services.AddTransient<IQAService, QAService>();
builder.Services.AddTransient<IRatingService, RatingService>();
builder.Services.AddTransient<IDonationService, DonationService>();
builder.Services.AddTransient<IUserProfilePictureService, UserProfilePictureService>();
builder.Services.AddTransient<IUserPostActionService, UserPostActionService>();
builder.Services.AddTransient<IUserCommentActionService, UserCommentActionService>();
builder.Services.AddScoped<IRabbitMQProducer, RabbitMQProducer>();
builder.Services.AddTransient<IRecommenderService, RecommenderService>();

// Add CORS policy before Build()
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy.WithOrigins("http://0.0.0.0:5000")  // Update the Flutter URL if needed
              .AllowAnyMethod();
    });
});

// Controllers and filters
builder.Services.AddControllers(x =>
{
    x.Filters.Add<ErrorFilter>();
});


// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[] {}
        }
    });
});

// Database
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<BioskopinaContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IBioskopinaService));

// Auth
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);

builder.Services.AddControllersWithViews();

var app = builder.Build();

// Migrate and train model
using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<BioskopinaContext>();

    if (!dataContext.Database.CanConnect())
    {
        dataContext.Database.Migrate();

        var recommenderService = scope.ServiceProvider.GetRequiredService<IRecommenderService>();
        try
        {
            await recommenderService.TrainMovieModelAsync();
        }
        catch (Exception)
        {
            // Log or handle exception if needed
        }
    }
}

// Stripe config
Env.Load("../.env");
string stripeSecretKey = Environment.GetEnvironmentVariable("STRIPE_SECRET_KEY") ?? "";
StripeConfiguration.ApiKey = stripeSecretKey;

// Middleware
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFlutter");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Run
app.Run();
