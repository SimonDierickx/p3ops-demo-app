using FluentValidation;
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

            // Configure FluentValidation on IServiceCollection, not on IMvcBuilder
            services.AddFluentValidationAutoValidation();
            services.AddFluentValidationClientsideAdapters();
            services.AddValidatorsFromAssembly(typeof(ProductDto.Mutate.Validator).Assembly);

            services.AddControllersWithViews();
            services.AddSwaggerGen(c =>
            {
                c.CustomSchemaIds(x => $"{x.DeclaringType.Name}.{x.Name}");
                c.Swag
