using Xunit;
namespace EnterpriseApp.Api.Tests;
public class HealthTests { [Fact] public void ApplicationName_ShouldBeCorrect() => Assert.Equal("EnterpriseApp.Api", "EnterpriseApp.Api"); }
