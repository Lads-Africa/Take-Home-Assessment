<?php

namespace Tests;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Laravel\Sanctum\Sanctum;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication;
    use RefreshDatabase;

    /**
     * Create an admin user model.
     */
    protected function createAdminUser(): User
    {
        return User::factory()->create([
            'email' => 'admin@test.com',
            'role'  => 'admin',
        ]);
    }

    /**
     * Create a normal user model.
     */
    protected function createNormalUser(): User
    {
        return User::factory()->create([
            'email' => 'user@test.com',
            'role'  => 'user',
        ]);
    }

    /**
     * Authenticate as admin via Sanctum and return the user.
     */
    protected function actingAsAdmin(): User
    {
        $admin = $this->createAdminUser();
        Sanctum::actingAs($admin);

        return $admin;
    }

    /**
     * Authenticate as normal user via Sanctum and return the user.
     */
    protected function actingAsUser(): User
    {
        $user = $this->createNormalUser();
        Sanctum::actingAs($user);

        return $user;
    }
}
