using Pomelo.EntityFrameworkCore.MySql.Infrastructure; // Add this for MySQL options

public void ConfigureServices(IServiceCollection services)
{
    services.AddDbContext<SportStoreDbContext>(options =>
    {
        options.UseMySql(
            Configuration.GetConnectionString("SqlDatabase"),
            new MySqlServerVersion(new Version(8, 0, 21)) // specify your MySQL version here
        );

        if (Environment.IsDevelopment())
        {
            options.EnableDetailedErrors();
            options.EnableSensitiveDataLogging();
            options.UseTriggers(triggers =>
            {
                triggers.AddTrigger<OnBeforeEntitySaved>();
            });
        }
    });

    // Other service configurations...
    services.AddFluentValidationAutoValidation();
    services.AddFluentValidationClientsideAdapters();
    services.AddValidatorsFromAssembly(typeof(ProductDto.Mutate.Validator).Assembly);

    services.AddControllersWithViews();
    services.AddSwaggerGen(c =>
    {
        c.CustomSchemaIds(x => $"{x.DeclaringType.Name}.{x.Name}");
        c.SwaggerDoc("v1", new OpenApiInfo { Title = "Sportstore API", Version = "v1" });
    });

    services.AddRazorPages();
    services.AddProductServices();
    services.AddScoped<SportStoreDataInitializer>();
}
