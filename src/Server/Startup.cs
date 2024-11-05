using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using Persistence;
using Persistence.Triggers;
using Services.Products;
using Shared.Products;

namespace Server
{
    public class Startup
    {
        public IConfiguration Configuration { get; }
        public IWebHostEnvironment Environment { get; }

        public Startup(IConfiguration configuration, IWebHostEnvironment environment)
        {
            Configuration = configuration;
            Environment = environment;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<SportStoreDbContext>(options =>
            {
                // Use Npgsql for PostgreSQL
                options.UseNpgsql(Configuration.GetConnectionString("SqlDatabase"));
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

            services.AddControllersWithViews()
                .AddFluentValidationAutoValidation() // Replaces AddFluentValidation()
                .AddFluentValidationClientsideAdapters() // Replaces implicit client-side validation
                .AddValidatorsFromAssemblyContaining<ProductDto.Mutate.Validator>(); // Updated validator registration method

            services.AddSwaggerGen(c =>
            {
                c.CustomSchemaIds(x => $"{x.DeclaringType.Name}.{x.Name}");
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "Sportstore API", Version = "v1" });
            });

            services.AddRazorPages();
            services.AddProductServices();
            services.AddScoped<SportStoreDataInitializer>();
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, SportStoreDataInitializer dataInitializer)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseWebAssemblyDebugging();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Sportstore API"));
            }
            else
            {
                app.UseExceptionHandler("/Error");
                app.UseHsts();
            }

            dataInitializer.SeedData();

            app.UseHttpsRedirection();
            app.UseBlazorFrameworkFiles();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapRazorPages();
                endpoints.MapControllers();
                endpoints.MapFallbackToFile("index.html");
            });
        }
    }
}
